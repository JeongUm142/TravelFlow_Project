package vo;

public class A {//템플릿패턴
	private String getFirstName() {
		return "구디";
	}
	private String getSecondName() {
		return "아카데미";
	}
	public String getFullName() {
		return this.getFirstName() +this.getSecondName();
	}
//	클래스내에서 실행하는 법
//	public static void main(String[] args) {
//		A a = new A();
//		String name = a.getFullName();
//		System.out.println(name);
//	}

}
