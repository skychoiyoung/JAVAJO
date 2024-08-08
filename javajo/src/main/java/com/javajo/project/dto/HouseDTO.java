package com.javajo.project.dto;

public class HouseDTO {
	private int house_num;
	private String user_id;
	private String house_name;
	private String house_addr;
	private int house_room;
	private int house_bed;
	private int house_bath;
	private int house_maxperson;
	private String house_image1;
	private String house_image2;
	private String house_image3;
	private String house_image4;
	private String house_image5;
	private String house_type;
	private String house_theme;
	private String house_fac;
	private String house_content;
	private int house_price;
	private String house_checkin;
	private String house_checkout;
	
	// 조인 테이블 컬럼
	private int house_score;
	private String htype_des;
	private String house_type_image;

	public int getHouse_num() {
		return house_num;
	}
	public void setHouse_num(int house_num) {
		this.house_num = house_num;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
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
	public int getHouse_room() {
		return house_room;
	}
	public void setHouse_room(int house_room) {
		this.house_room = house_room;
	}
	public int getHouse_bed() {
		return house_bed;
	}
	public void setHouse_bed(int house_bed) {
		this.house_bed = house_bed;
	}
	public int getHouse_bath() {
		return house_bath;
	}
	public void setHouse_bath(int house_bath) {
		this.house_bath = house_bath;
	}
	public int getHouse_maxperson() {
		return house_maxperson;
	}
	public void setHouse_maxperson(int house_maxperson) {
		this.house_maxperson = house_maxperson;
	}
	public String getHouse_image1() {
		return house_image1;
	}
	public void setHouse_image1(String house_image1) {
		this.house_image1 = house_image1;
	}
	public String getHouse_image2() {
		return house_image2;
	}
	public void setHouse_image2(String house_image2) {
		this.house_image2 = house_image2;
	}
	public String getHouse_image3() {
		return house_image3;
	}
	public void setHouse_image3(String house_image3) {
		this.house_image3 = house_image3;
	}
	public String getHouse_image4() {
		return house_image4;
	}
	public void setHouse_image4(String house_image4) {
		this.house_image4 = house_image4;
	}
	public String getHouse_image5() {
		return house_image5;
	}
	public void setHouse_image5(String house_image5) {
		this.house_image5 = house_image5;
	}
	public String getHouse_type() {
		return house_type;
	}
	public void setHouse_type(String house_type) {
		this.house_type = house_type;
	}
	
	public String getHouse_theme() {
		return house_theme;
	}
	public void setHouse_theme(String house_theme) {
		this.house_theme = house_theme;
	}
	public String getHouse_fac() {
		return house_fac;
	}
	public void setHouse_fac(String house_fac) {
		this.house_fac = house_fac;
	}
	public String getHouse_content() {
		return house_content;
	}
	public void setHouse_content(String house_content) {
		this.house_content = house_content;
	}
	public int getHouse_price() {
		return house_price;
	}
	public void setHouse_price(int house_price) {
		this.house_price = house_price;
	}
	public String getHouse_checkin() {
		return house_checkin;
	}
	public void setHouse_checkin(String house_checkin) {
		this.house_checkin = house_checkin;
	}
	public String getHouse_checkout() {
		return house_checkout;
	}
	public void setHouse_checkout(String house_checkout) {
		this.house_checkout = house_checkout;
	}
	
	// 조인된 테이블 getter, setter
	public int getHouse_score() {
		return house_score;
	}
	public void setHouse_score(int house_score) {
		this.house_score = house_score;
	}
	public String getHtype_des() {
		return htype_des;
	}
	public void setHtype_des(String htype_des) {
		this.htype_des = htype_des;
	}
	public String getHouse_type_image() {
		return house_type_image;
	}
	public void setHouse_type_image(String house_type_image) {
		this.house_type_image = house_type_image;
	}
}
