import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;



public class ControllerServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ServletContext sc = getServletContext();
        RequestDispatcher form = sc.getRequestDispatcher("/index.jsp");
        form.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ServletContext sc = getServletContext();

        RequestDispatcher form = sc.getRequestDispatcher("/index.jsp");
        RequestDispatcher script = sc.getRequestDispatcher("/script/");
        if (request.getParameter("clear") != null)
        {
            sc.removeAttribute("history");
            sc.removeAttribute("historyArray");
        }
        if (request.getParameter("r") == null || request.getParameter("x") == null || request.getParameterValues("Y") == null && request.getParameter("Y1").equals(""))
            form.forward(request, response);
        script.forward(request, response);
    }
}
