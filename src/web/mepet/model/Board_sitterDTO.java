package web.mepet.model;

import java.sql.Timestamp;

public class Board_sitterDTO {
	private int num;
	private String id;
	private String name;
	private String subject;
	private String content;
	private String img;
	private int readcount;
	private String ip;
	private Timestamp reg;
	private double avgpoint;
	private String area;
	
	public double getAvgpoint() {
		return avgpoint;
	}
	public void setAvgpoint(double avgpoint) {
		this.avgpoint = avgpoint;
	}
	public String getArea() {
		return area;
	}
	public void setArea(String area) {
		this.area = area;
	}
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getSubject() {
		return subject;
	}
	public void setSubject(String subject) {
		this.subject = subject;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getImg() {
		return img;
	}
	public void setImg(String img) {
		this.img = img;
	}
	public int getReadcount() {
		return readcount;
	}
	public void setReadcount(int readcount) {
		this.readcount = readcount;
	}
	public String getIp() {
		return ip;
	}
	public void setIp(String ip) {
		this.ip = ip;
	}
	public Timestamp getReg() {
		return reg;
	}
	public void setReg(Timestamp reg) {
		this.reg = reg;
	}
}
