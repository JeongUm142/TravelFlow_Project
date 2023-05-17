package vo;

import java.util.Calendar;

public class Person {//입력은 가능하나 볼 수는 없음
	private int birth; // 필드 은닉
	
	/*불필요
	 	private int getBirth() { // 읽기-getter은닉 하려면 지우거나 private return birth; }
	 */ 

	public void setBirth(int birth) { // 쓰기
		if(birth > 0 ){
			this.birth = birth;
		}
	}
	
	public int getAge() {
		if(this.birth>0){
			Calendar c = Calendar.getInstance();
			int y = c.get(Calendar.YEAR);
			return y - this.birth;
		}
		return 0;
	}
}
