package com.hospital.jo;

/**
 * @author liyu
 */
public class JoDisease {
    private int id;
    private String name;
    private String icd;
    private int typeId;
    private String type;

    @Override
    public String toString() {
        return "JoDisease{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", icd='" + icd + '\'' +
                ", typeId=" + typeId +
                ", type='" + type + '\'' +
                '}';
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

    public String getIcd() {
        return icd;
    }

    public void setIcd(String icd) {
        this.icd = icd;
    }

    public int getTypeId() {
        return typeId;
    }

    public void setTypeId(int typeId) {
        this.typeId = typeId;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }
}
