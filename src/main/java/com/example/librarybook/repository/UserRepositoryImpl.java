package com.example.librarybook.repository;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.example.librarybook.model.User;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;
import jakarta.transaction.Transactional;

@Repository
@Transactional
public class UserRepositoryImpl implements UserRepositoryCustom {
    
    @PersistenceContext
    private EntityManager entityManager;

    @SuppressWarnings("unchecked")
    @Override
    public List<User> findUserByRequest(String username, String fullName, String phoneNumber, String email, String role, Integer status, Long offset, Long pageSize){
        StringBuilder sql = new StringBuilder("SELECT u.* FROM USERS as u");

        StringBuilder where = new StringBuilder(" WHERE 1=1 ");
        queryNomal(username, fullName, phoneNumber, email, role, status, where);

        where.append(" GROUP BY u.id, u.phoneNumber, u.role, u.email, u.username, u.address, u.fullName, u.imageURL, u.password, u.status");
        sql.append(where);
        sql.append(" ORDER BY u.id DESC");
        sql.append(" OFFSET ").append(offset).append(" ROWS FETCH NEXT ").append(pageSize).append(" ROWS ONLY");
        Query query = entityManager.createNativeQuery(sql.toString(), User.class);
        return query.getResultList();
    }

    @Override
    public Long findUserCountByRequest(String username, String fullName, String phoneNumber, String email, String role, Integer status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM USERS as u");
    
        StringBuilder where = new StringBuilder(" WHERE 1=1 ");
        queryNomal(username, fullName, phoneNumber, email, role, status, where);
    
        sql.append(where);
    
        Query query = entityManager.createNativeQuery(sql.toString());
        Number countResult = (Number) query.getSingleResult();
        return countResult.longValue();
    }
    

    private void queryNomal(String username, String fullName, String phoneNumber, String email, String role, Integer status , StringBuilder sql){
        if(username != null && !username.isEmpty()){
            sql.append(" AND u.username LIKE N'%").append(username).append("%' ");
        }
        if(fullName != null && !fullName.isEmpty()){
            sql.append(" AND u.fullName LIKE N'%").append(fullName).append("%' ");
        }
        if(phoneNumber != null && !phoneNumber.isEmpty()){
            sql.append(" AND u.phoneNumber LIKE N'%").append(phoneNumber).append("%' ");
        }
        if(email != null && !email.isEmpty()){
            sql.append(" AND u.email LIKE N'%").append(email).append("%' ");
        }
        if(role != null && !role.isEmpty()){
            sql.append(" AND u.role = '").append(role).append("' ");
        }
        sql.append(" AND u.status = ").append(status);
    }
}
