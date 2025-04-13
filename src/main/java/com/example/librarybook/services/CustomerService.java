package com.example.librarybook.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.librarybook.repository.CustomerRepository;
import com.example.librarybook.model.Customer;

import java.util.List;

@Service
public class CustomerService {
    @Autowired
    private CustomerRepository customerRepository;

    // Lấy danh sách tất cả khách hàng
    public List<Customer> getAllCustomer(){
        return customerRepository.findAll();
    }

    // Tìm kiếm tài khoản theo tên
    public List<Customer> getCustomerbyName(String keyword){
        return customerRepository.findByUser_FullNameContaining(keyword);
    }

    //Thêm hoặc cập nhật khách hàng
    public Customer saveCustomer(Customer customer){
        return customerRepository.save(customer);
    }

    //Xóa khách hàng theo id
    public void deleteCustomer(Integer id){
        customerRepository.deleteById(id);
    }

    public Customer getCustomerById(Long id){
        return customerRepository.findById(id);
    }

    public Customer getCustomerByUserId(Long id){
        return customerRepository.findByUser_Id(id);
    }
}
