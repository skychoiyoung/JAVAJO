package com.javajo.project.dto;

public class WishListDTO {
	private String user_id;
	private String house_num;
	
	// 조인된 테이블 필드
	private String house_name;
	private String house_addr;
	private String house_image1;
	private int house_price;
	
	public String getHouse_name() {
		return house_name;
	}
	public void setHouse_name(String house_name) {
		this.house_name = house_name;
	}
	public String getHouse_addr() {
		return house_addr;
	}
	public void setHouse_addr(String house_addr) {
		this.house_addr = house_addr;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	
	// 조인된 테이블 getter, setter
	public String getHouse_num() {
		return house_num;
	}
	public void setHouse_num(String house_num) {
		this.house_num = house_num;
	}
	public String getHouse_image1() {
		return house_image1;
	}
	public void setHouse_image1(String house_image1) {
		this.house_image1 = house_image1;
	}
	public int getHouse_price() {
		return house_price;
	}
	public void setHouse_price(int house_price) {
		this.house_price = house_price;
	}
}
