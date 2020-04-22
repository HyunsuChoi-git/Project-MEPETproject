package web.mepet.model;

import java.sql.Timestamp;

public class Member_petDTO {
	private String id;
	private String type;
	private String pettype;
	private String petname;
	private int petage;
	private String petsex;
	private String petsize;
	private double petweight;
	private String petneutral;
	private String img;
	private Timestamp reg;
	private int petnum;
	
	public int getPetnum() {
		return petnum;
	}
	public void setPetnum(int petnum) {
		this.petnum = petnum;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getPettype() {
		return pettype;
	}
	public void setPettype(String pettype) {
		this.pettype = pettype;
	}
	public String getPetname() {
		return petname;
	}
	public void setPetname(String petname) {
		this.petname = petname;
	}
	public int getPetage() {
		return petage;
	}
	public void setPetage(int petage) {
		this.petage = petage;
	}
	public String getPetsex() {
		return petsex;
	}
	public void setPetsex(String petsex) {
		this.petsex = petsex;
	}
	public String getPetsize() {
		return petsize;
	}
	public void setPetsize(String petsize) {
		this.petsize = petsize;
	}
	public double getPetweight() {
		return petweight;
	}
	public void setPetweight(double petweight) {
		this.petweight = petweight;
	}
	public String getPetneutral() {
		return petneutral;
	}
	public void setPetneutral(String petneutral) {
		this.petneutral = petneutral;
	}
	public String getImg() {
		return img;
	}
	public void setImg(String img) {
		this.img = img;
	}
	public Timestamp getReg() {
		return reg;
	}
	public void setReg(Timestamp reg) {
		this.reg = reg;
	}
	
}
