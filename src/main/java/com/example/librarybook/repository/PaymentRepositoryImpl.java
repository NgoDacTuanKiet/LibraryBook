package com.example.librarybook.repository;

import java.util.List;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.example.librarybook.model.Payment;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;

@Repository
@Transactional
public class PaymentRepositoryImpl implements PaymentReopsitoryCustom{
    @PersistenceContext
    private EntityManager entityManager;

    @SuppressWarnings("unchecked")
    @Override
    public List<Payment> findPaymentByRequest(String customerFullName, String employeeFullName, String customerPhoneNumber){
        StringBuilder sql = new StringBuilder(" SELECT p.* " +
                                              " From Payment as p ");
        joinTable(customerFullName, customerPhoneNumber, employeeFullName, sql);

        sql.append(" WHERE 1=1 ");
        querySpecial(customerFullName, customerPhoneNumber, employeeFullName, sql);
        Query query = entityManager.createNativeQuery(sql.toString(), Payment.class);
        return query.getResultList();
    }

    private void joinTable(String customerFullName, String customerPhoneNumber, String employeeFullName, StringBuilder sql){
        int ok = 0;
        if ((customerFullName != null && !customerFullName.isEmpty()) || 
        (customerPhoneNumber != null && !customerPhoneNumber.isEmpty())) {
            ok += 1;
            sql.append(" INNER JOIN Customer as c on c.id = p.customerID ");
        }
        if (employeeFullName != null && !employeeFullName.isEmpty()){
            ok += 2;
            sql.append(" INNER JOIN Employee as e on e.id = p.employeeID ");
        }
        if(ok == 1){
            sql.append(" INNER JOIN Users as u on u.id = c.userID ");
        } else if (ok == 2){
            sql.append(" INNER JOIN Users as u on u.id = e.userID ");
        } else if (ok == 3){
            sql.append(" INNER JOIN Users as u on u.id = c.userID OR u.id = e.userID ");
        }
    }

    private void querySpecial(String customerFullName, String customerPhoneNumber, String employeeFullName, StringBuilder sql){
        if(customerFullName != null && !customerFullName.isEmpty()){
            sql.append(" AND u.fullName LIKE N'%").append(customerFullName).append("%' ");
        }
        if(customerPhoneNumber != null && !customerPhoneNumber.isEmpty()){
            sql.append(" AND u.phoneNumber LIKE N'%").append(customerPhoneNumber).append("%' ");
        }
        if(employeeFullName != null && !employeeFullName.isEmpty()){
            sql.append(" AND u.fullName LIKE N'%").append(employeeFullName).append("%' ");
        }
    }
}
