package beanie.hello;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class HelloServlet
 */
/*
1. Servlet Annotation =>@WebServlet("/hello")
2. Servlet Annotation으로 지정된 이름을 가지고 서블릿을 호출할 수 있다. 
3. 만약 Servlet Annotation을 사용하지 않고 서블릿을 호출하려면 web.xml파일(DD파일)에 서블릿 정보를 추가해야 한다.
4. url-pattern 지정하는 방법 3가지 
	1) extension matching => *.do *.nhn *.acorn (확장자는 마음대로) 
	2) exact matching => /test, /acorn, /test/acorn (정확하게 써주는 것) 
	3) wildcard matching => /test/*, /acorn/*
		(앞에 지정했던 네임이 오면 뒤에는 아무거나 와도 상관X) 
	2번, 3번은 반드시 /로 시작해야하고, 1번은 /로 시작하면 안된다.
 */
@WebServlet("/HelloServlet")
public class HelloServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public HelloServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	// get, post방식 관계없이 service로 처리 가능
	protected void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		// 응답 MIME 타입과 문자 인코딩을 지정한다.
		response.setContentType("text/html;charset=utf-8");
		// 클라이언트에게 응답할 출력객체를 생성한다.
		PrintWriter out = response.getWriter();
		out.println("<!DOCTYPE html>");
		out.println("<html>");
		out.println("<body>");
		out.println("<h1>Hello World! I am hanbinLee</h1>");
		String id = request.getParameter("id");
		String age = request.getParameter("age");
		out.println(id + "," + age);
		out.println("</body>");
		out.println("</html>");

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
			// post방식은 여기서는 쓰일일이 별로 없다.
	}

}
