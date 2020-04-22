package web.mepet.model;

import java.sql.Timestamp;

public class Board_commentDTO {
	private int num;
	private String id;
	private String nick;
	private String subject;
	private String content;
	private String petdate;
	private String petday;
	private String area;
	private String sitter_name;
	private int point;
	private String img;
	private int ref;
	private int re_step;
	private int readcount;
	private String ip;
	private Timestamp reg;
	
	
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
	public String getNick() {
		return nick;
	}
	public void setNick(String nick) {
		this.nick = nick;
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
	public String getPetdate() {
		return petdate;
	}
	public void setPetdate(String petdate) {
		this.petdate = petdate;
	}
	public String getPetday() {
		return petday;
	}
	public void setPetday(String petday) {
		this.petday = petday;
	}
	public String getArea() {
		return area;
	}
	public void setArea(String area) {
		this.area = area;
	}
	public String getSitter_name() {
		return sitter_name;
	}
	public void setSitter_name(String sitter_name) {
		this.sitter_name = sitter_name;
	}
	public int getPoint() {
		return point;
	}
	public void setPoint(int point) {
		this.point = point;
	}
	public String getImg() {
		return img;
	}
	public void setImg(String img) {
		this.img = img;
	}
	public int getRef() {
		return ref;
	}
	public void setRef(int ref) {
		this.ref = ref;
	}
	public int getRe_step() {
		return re_step;
	}
	public void setRe_step(int re_step) {
		this.re_step = re_step;
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
