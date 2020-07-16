package com.hospital.controller;

import com.hospital.domain.User;
import com.hospital.mapper.IUserMapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.SessionAttributes;

import javax.servlet.http.HttpServletRequest;
import java.util.Enumeration;

/**
 * @author liyu
 */
@RestController
@RequestMapping("/user")
@SessionAttributes("user")
public class UserController {

    @Autowired
    private IUserMapper iUserMapper;

    @RequestMapping("/login")
    public User login(String userName, String password, Model model,HttpServletRequest request) {
        // 因为都会直接返回数据，所以要提前创建session，否则会报错
        if(request.getSession(false)==null){
            request.getSession();
        }
        User user = null;

        if (userName == null || userName.length() == 0 || password == null || password.length() == 0) {
            return null;
        } else {
            user = iUserMapper.login(userName, password);
            // 密码不进行返回
            if (user != null) {
                user.setPassword("");
                model.addAttribute("user", user);
            }
        }
        return user;
    }
}
