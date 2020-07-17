package com.hospital.mapper;

import com.hospital.domain.Invoice;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Repository;

/**
 * @author liyu
 */
@Mapper
@Repository
public interface IInvoiceMapper {

    /**
     * 添加发票
     * @param invoice 发飘票内容
     */
    public void insertInvovice(Invoice invoice);

    /**
     * 获得最大发票num
     * @return 最大发票num
     */
    @Select(" SELECT MAX(number) FROM invoice")
    public int SelectMaxInvoiceNum();
}
