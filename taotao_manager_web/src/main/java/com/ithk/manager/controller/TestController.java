package com.ithk.manager.controller;

import com.alibaba.dubbo.config.annotation.Reference;
import com.ithk.manager.service.TestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping(value = "/test")
public class TestController {

    @Autowired
    private TestService testService;

    /**
     * 环境测试
     * @return
     */
    @RequestMapping(value = "/queryDate")
    @ResponseBody
    public String queryDate(){
        return testService.queryDate();
    }
}
