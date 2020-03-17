import java.io.*;
import java.sql.Array;
import javax.servlet.*;
import javax.servlet.http.*;

public class AreaCheckServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html; charset=utf-8");
        double x = Double.valueOf(request.getParameter("x"));
        double r = Double.valueOf(request.getParameter("r"));
        String[] Y;
        if (!request.getParameter("Y1").equals("")) {
            Y = new String[1];
            Y[0] = request.getParameter("Y1");
        } else
        Y = request.getParameterValues("Y");
        boolean[] res = new boolean[Y.length];

        PrintWriter out = response.getWriter();
        out.println("<table>");
        out.println("<tr><td> X: </td><td> Y: </td><td> R: </td><td> Результат: </td></tr>");
        for (int i = 0; i < Y.length; i++) {
            double y = Double.valueOf(Y[i]);
            res[i] = false;
            if (x <= 0 && y <= 0) {
                res[i] = (x * x + y * y <= r * r);
            }
            if (!res[i] && x <= 0 && y >= 0) {
                res[i] = (y - 2*x <= r);
            }
            if (!res[i] && x >= 0 && y <= 0) {
                res[i] = (x <= r) && (y >= -r / 2);
            }
            out.println("<tr><td>" + Double.toString(x) + "</td><td>" + Y[i] + "</td><td>" + Double.toString(r) + "</td><td style=\"text-align: center\">" + (res[i] ? "попала" : "промах!") + "</td></tr>");
        }
        out.println("</table>");
        out.println("<a href = \"/lab2/\"> Попробуем еще раз? </a>");


        ServletContext sc = getServletContext();
        if (sc.getAttribute("history") == null || !(sc.getAttribute("history") instanceof String))
            sc.setAttribute("history", "");
        if (sc.getAttribute("historyArray") == null || !(sc.getAttribute("historyArray") instanceof String))
            sc.setAttribute("historyArray", "");

        String history = (String) sc.getAttribute("history");
        String historyArray = (String) sc.getAttribute("historyArray");
        for (int i = 0; i < Y.length; i++) {
            history +=  "<tr><td>" + Double.toString(x) + "</td><td>" + Y[i] + "</td><td>"
                    + Double.toString(r) + "</td><td>" + (res[i] ? "попала" : "промах!") + "</td></tr>";
            historyArray += ((historyArray.length() > 0) ? "," : "") + " {x: " + Double.toString(x) + ", y: " + Double.toString(Double.valueOf(Y[i])) + ", r: " + Double.toString(r) + ", col: \"" + (res[i] ? "#0f0" : "#f00") + "\"}";
        }
        sc.setAttribute("history", history);
        sc.setAttribute("historyArray", historyArray);
    }
}
