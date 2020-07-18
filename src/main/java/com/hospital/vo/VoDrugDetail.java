package com.hospital.vo;

import java.math.BigDecimal;

/**
 * @author liyu
 */
public class VoDrugDetail {
    private String drugCode;
    private int id;
    private String name;
    private String specification;
    private BigDecimal price;
    private String pack;
    private String form;
    private String type;

    @Override
    public String toString() {
        return "VoDrugDetail{" +
                "drugCode='" + drugCode + '\'' +
                ", id=" + id +
                ", name='" + name + '\'' +
                ", specification='" + specification + '\'' +
                ", price=" + price +
                ", pack='" + pack + '\'' +
                ", form='" + form + '\'' +
                ", type='" + type + '\'' +
                '}';
    }

    public String getDrugCode() {
        return drugCode;
    }

    public void setDrugCode(String drugCode) {
        this.drugCode = drugCode;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSpecification() {
        return specification;
    }

    public void setSpecification(String specification) {
        this.specification = specification;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getPack() {
        return pack;
    }

    public void setPack(String pack) {
        this.pack = pack;
    }

    public String getForm() {
        return form;
    }

    public void setForm(String form) {
        this.form = form;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }
}
