package web.mepet.model;

import java.sql.Timestamp;

public class MepetsitterDTO {
	private String id;
	private String pw;
	private String name;
	private int phon;
	private String email;
	private String area;
	private int year;
	private int sittercount;
	private int point;
	private double avgpoint;
	private String img;
	private Timestamp reg;
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPw() {
		return pw;
	}
	public void setPw(String pw) {
		this.pw = pw;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getPhon() {
		return phon;
	}
	public void setPhon(int phon) {
		this.phon = phon;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getArea() {
		return area;
	}
	public void setArea(String area) {
		this.area = area;
	}
	public int getYear() {
		return year;
	}
	public void setYear(int year) {
		this.year = year;
	}
	public int getSittercount() {
		return sittercount;
	}
	public void setSittercount(int sittercount) {
		this.sittercount = sittercount;
	}
	public int getPoint() {
		return point;
	}
	public void setPoint(int point) {
		this.point = point;
	}
	public double getAvgpoint() {
		return avgpoint;
	}
	public void setAvgpoint(double avgpoint) {
		this.avgpoint = avgpoint;
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

