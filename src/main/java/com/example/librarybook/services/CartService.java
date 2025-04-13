package com.example.librarybook.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.librarybook.model.Cart;
import com.example.librarybook.model.CartDetail;
import com.example.librarybook.repository.CartDetailRepository;
import com.example.librarybook.repository.CartRepository;

@Service
public class CartService {

    @Autowired
    private CartRepository cartRepository;

    @Autowired
    private CartDetailRepository cartDetailRepository;

    public Cart findById(Long id){
        return cartRepository.findById(id).get();
    }

    public Cart getCartByCustomerId(Long customerId){
        return cartRepository.findByCustomer_Id(customerId);
    }

    public Cart saveCart(Cart cart){
        return cartRepository.save(cart);
    }

    public Cart removeCartDetailById(Cart cart, Long cartDetailId){
        CartDetail tmp = cartDetailRepository.findById(cartDetailId).get();
        cart.getCartDetails().remove(tmp);
        return cartRepository.save(cart);
    }

    public Cart deleteAllCartDetail(Cart cart){
        cart.getCartDetails().clear();
        return cartRepository.save(cart);
    }
}
