package com.example.librarybook.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.librarybook.model.CartDetail;
import com.example.librarybook.repository.CartDetailRepository;

@Service
public class CartDetailService {
    @Autowired
    private CartDetailRepository cartDetailRepository;

    public CartDetail saveCartDetail(CartDetail cartDetail){
        return cartDetailRepository.save(cartDetail);
    }

    public CartDetail updateCartDetailById(Long cartDetailId, Long newQuantity){
        CartDetail tmp = cartDetailRepository.findById(cartDetailId).get();
        tmp.setQuantity(newQuantity);
        return cartDetailRepository.save(tmp);
    }

    public CartDetail findById(Long id){
        return cartDetailRepository.findById(id).get();
    }
}
