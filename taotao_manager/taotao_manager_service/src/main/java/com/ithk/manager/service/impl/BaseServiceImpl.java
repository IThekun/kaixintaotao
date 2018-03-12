package com.ithk.manager.service.impl;

import com.github.abel533.entity.Example;
import com.github.abel533.mapper.Mapper;
import com.github.pagehelper.PageHelper;
import com.ithk.manager.service.BaseService;
import org.springframework.beans.factory.annotation.Autowired;

import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.List;

public class BaseServiceImpl<T> implements BaseService<T> {


    @Autowired
    private Mapper<T> mapper;

    private Class<T> clazz;

    public BaseServiceImpl() {
        // 获取父类的type
        Type type = this.getClass().getGenericSuperclass();

        // 强转为ParameterizedType，可以使用获取泛型类型的方法
        ParameterizedType pType = (ParameterizedType) type;

        // 获取泛型的class
        this.clazz = (Class<T>) pType.getActualTypeArguments()[0];
    }

    @Override
    public T queryById(Long id) {
        T t = this.mapper.selectByPrimaryKey(id);
        return t;
    }

    @Override
    public List<T> queryAll() {
        List<T> list = this.mapper.select(null);
        return list;
    }

    @Override
    public Integer queryCountByWhere(T t) {
        int count = this.mapper.selectCount(t);
        return count;
    }

    @Override
    public List<T> queryListByWhere(T t) {
        List<T> list = this.mapper.select(t);
        return list;
    }

    @Override
    public List<T> queryByPage(Integer page, Integer rows) {
        PageHelper.startPage(page, rows);

        List<T> list = this.mapper.select(null);

        return list;
    }

    @Override
    public T queryOne(T t) {
        T result = this.mapper.selectOne(t);
        return result;
    }

    @Override
    public void save(T t) {
        this.mapper.insert(t);
    }

    @Override
    public void saveSelective(T t) {
        this.mapper.insertSelective(t);
    }

    @Override
    public void updateById(T t) {
        this.mapper.updateByPrimaryKey(t);
    }

    @Override
    public void updateByIdSelective(T t) {
        this.mapper.updateByPrimaryKeySelective(t);
    }

    @Override
    public void deleteById(Long id) {
        this.mapper.deleteByPrimaryKey(id);
    }

    @Override
    public void deleteByIds(List<Object> ids) {
        // 声明条件
        Example example = new Example(this.clazz);
        example.createCriteria().andIn("id", ids);

        this.mapper.deleteByExample(example);
    }
}
