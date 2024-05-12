package com.ithe.controller;

import com.ithe.pojo.User;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.lang.invoke.VarHandle;
import java.util.Arrays;

@RestController
public class RequestController {
//    @RequestMapping("/simpleParam")
//    public String simpleParam(HttpServletRequest request) {
//        String name = request.getParameter("name");
//        String ageStr = request.getParameter("age");
//        int age = Integer.parseInt(ageStr);
//        System.out.println(name + ":" + age);
//        return "OK";
//
//    }
    @RequestMapping("/simpleParam")
    public String simpleParam(String name, Integer age) {
        System.out.println(name + ": " + age);
        return "OK";

    }


    @RequestMapping("/simplePojo")
    public String simplePojo(User user){
        System.out.println(user);
        return "OK";
    }

    @RequestMapping("/arrayParam")
    public String arrayParam (String[] hobby){
        System.out.println(Arrays.toString(hobby));
        return "OK";

    }

}
