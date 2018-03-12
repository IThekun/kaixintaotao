package com.ithk.manager.service.impl;

import com.ithk.manager.mapper.TestMapper;
import com.ithk.manager.service.TestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

@Service
public class TestServiceImpl implements TestService {

    @Autowired
    private TestMapper testMapper;

    @Override
    public String queryDate() {
        return testMapper.queryDate();
    }
}
