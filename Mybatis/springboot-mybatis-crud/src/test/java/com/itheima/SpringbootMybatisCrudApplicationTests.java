package com.itheima;

import com.itheima.mapper.EmpMapper;
import com.itheima.pojo.Emp;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@SpringBootTest
class SpringbootMybatisCrudApplicationTests {

    @Autowired
    private EmpMapper empMapper;

    @Test
    public void testDelete() {
        empMapper.delete(17);
    }

    @Test
    public void testInsert() {
        //创建员工对象
        Emp emp = new Emp();
        emp.setUsername("tom3");
        emp.setName("汤姆");
        emp.setImage("1.jpg");
        emp.setGender((short) 1);
        emp.setJob((short) 1);
        emp.setEntrydate(LocalDate.of(2000, 1, 1));
        emp.setCreateTime(LocalDateTime.now());
        emp.setUpdateTime(LocalDateTime.now());
        emp.setDeptId(1);
        //调用添加方法
        empMapper.insert(emp);
        System.out.println(emp.getId());
    }

    @Test
    public void testUpdate() {
        //要修改的员工信息
        Emp emp = new Emp();
        emp.setId(18);
        emp.setUsername("songdaxia");
        emp.setPassword(null);
        emp.setName("老宋");
        emp.setImage("2.jpg");
        emp.setGender((short) 1);
        emp.setJob((short) 2);
        emp.setEntrydate(LocalDate.of(2012, 1, 1));
        emp.setCreateTime(null);
        emp.setUpdateTime(LocalDateTime.now());
        emp.setDeptId(2);
        //调用方法，修改员工数据
        empMapper.update(emp);
    }


    @Test
    public void testGetById() {
        Emp emp = empMapper.getById(13);
        System.out.println(emp);
    }

    @Test
    public void testList() {
//        List<Emp> list = empMapper.list("张", (short) 1, LocalDate.of(2010,1,1), LocalDate.of(2020,1,1));
//        List<Emp> list = empMapper.list("张", null, null, null);
//        List<Emp> list = empMapper.list("张", (short) 1, null, null);
        List<Emp> list = empMapper.list(null, (short) 1, null, null);
        for (Emp emp : list) {
            System.out.println(emp);
        }
    }
}
