package vo;
// 필드 정보은닉 + 필드 캡슐화
public class Data3 {
	private int x; //정보은닉
	private int y; //정보은닉
	
	//특정한 메소드로 호출하면 보여줌
	public int getX() { // 읽기 캡슐화 메서드
		return this.x;//스테이틱과 동일하게 쓸 수 없음
		//나의 리턴값
	}
	public int getY() { // 읽기 캡슐화 메서드
		return this.y;//스테이틱과 동일하게 쓸 수 없음
		//나의 리턴값
	}
	
	public void setX(int x) { // 쓰기 캡슐화 메서드
		this.x = x;
		//this.x = x;
	}
	
	public void setY(int y) { // 쓰기 캡슐화 메서드
		this.y = y;
		//this.y = y;
	}
	
	//Data d3_1 = new Data3();
	//d3_1.getX(); -d3-1의 x로 아래 d3-2 x와는 다른 값
	//Data d3_2 = new Data3();
	//d3_2.getX();
}
