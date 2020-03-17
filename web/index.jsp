<%@ page language="java" contentType="text/html; charset=utf-8" import="java.util.*,java.io.*"%>
<html>
<head>
    <title>lab2</title>
    <script>
        function verify(form)
        {
            let x = form.x.value;
            if (!x) {
                alert("Пожалуйста, введите значение Х");
                return false;
            }
            if (isNaN(x)) {
                alert("X дожен быть числом");
                return false;
            }
            if (x > 3 || x < -5)
            {
                alert("X должен быть в пределах от -5 до 3");
                return false;
            }
            let checker = false;
            for (let Y = form.Y, j = 0, J = Y.length; j < J; j++)
                if (Y[j].checked) {
                    checker = true;
                    break;
                }
            if (!checker) {
                alert("Пожалуйста, выберите значение Y");
                return false;
            }
            return true;
        }
        function drawStroke(context, x, y, dx, dy, caption) //рисует черточку на оси и подписывает её
        {
            context.beginPath();
            context.moveTo(x + dy, y - dx);
            context.lineTo(x - dy, y + dx);
            context.stroke();
            context.fillText(caption, x + 2, y - 2);
        }
        function arrow(context, xs, ys, xf, yf, strokes, caption) //рисует ось с черточками и подписывает её
        {
            context.beginPath();
            context.fillStyle = "#000";
            context.moveTo(xs, ys);
            context.lineTo(xf, yf);
            let dx = xf - xs, dy = yf - ys;
            let len = Math.sqrt(dx * dx + dy * dy);
            dx *= 6/len, dy *= 6/len;
            context.lineTo(xf - (dy + dx), yf - (dy - dx));
            context.moveTo(xf, yf);
            context.lineTo(xf - (dx - dy), yf - (dy + dx));
            context.stroke();
            context.fillText(caption, xf + 2, yf - 2);
            for (let i = 0; i < strokes.length; i++)
                drawStroke(context, strokes[i].x, strokes[i].y, dx, dy, strokes[i].caption);
        }
        function fatDot(context, x, y, col)
        {
            x = Math.round(x);
            y = Math.round(y);
            context.fillStyle = col;
            context.beginPath();
            context.arc(x, y, 2, 0, 2 * Math.PI);
            context.fill();
        }
        function draw_canvas()
        {
            let R = 100;
            let r = document.forms["form"].r.value;
            let bound = 130;
            let x0 = 150, y0 = 150;
            let col = "#3399ff";
            let canvas = document.getElementById("canvas");
            let context = canvas.getContext("2d");
            context.clearRect(0, 0, canvas.width, canvas.height)
            let dots = [
                <%= application.getAttribute("historyArray")%>
            ];
            context.beginPath();
            context.fillStyle = col;
            context.arc(x0, y0, R, -Math.PI, -3*Math.PI / 2, true);
            context.lineTo(x0, y0 + R/2);
            context.lineTo(x0 + R, y0 + R/2);
            context.lineTo(x0 + R, y0);
            context.lineTo(x0, y0);
            context.lineTo(x0, y0 - R);
            context.lineTo(x0 - R/2, y0);
            context.fill();
            context.font = "10pt Arial";
            ystrokes = [{x: x0, y: y0 + R, caption: "-R"}, {x: x0, y: y0 - R, caption: "R"}]
            arrow(context, x0, y0 + bound, x0, y0 - bound, ystrokes, "Y");
            xstrokes = [{x: x0 + R, y: y0, caption: "R"}, {x: x0 - R / 2, y:y0, caption: "-R/2"},  {x: x0 - R, y: y0, caption: "-R"}]
            arrow(context, x0 - bound, y0, x0 + bound, y0, xstrokes, "X");

            for (let i = 0; i < dots.length; i++)
                if (dots[i] != null){
                    let x = dots[i].x / r * R;
                    let y = dots[i].y / r * R;
                    if (-bound < x && x < bound && -bound < y && y < bound)
                        fatDot(context, x0 + x, y0 - y, dots[i].col);
                }
        }
        window.onload = function ()
        {
            //отрисовываем всю фигуру
            draw_canvas();
            let x0 = 150, y0 = 150, R = 100;
            canvas.addEventListener("click", function (event)
            {
                let r = form.r.value;
                let cur = canvas;
                let x = event.clientX;
                let y = event.clientY;
                do
                {
                    x -= cur.offsetLeft - cur.scrollLeft;
                    y -= cur.offsetTop - cur.scrollTop;
                }
                while (cur = cur.offsetParent)
                x = ((x - x0) / R) * r;
                y = ((y0 - y) / R) * r;
                form.Y1.value = y;
                form.x.value = x;
                document.getElementById("form").submit();
            } );
        }
    </script>
    <style type="text/css">
        span {
            margin: auto;
            text-align: center;
        }
        table {
            margin: auto;
        }
        table.form td
        {
            vertical-align: center;
        }
        table.history
        {
            border-spacing:  1px;
        }
        table.history td
        {
            border: 1px solid black;
            width: 80px;
            text-align: center;
        }
        label
        {
            height: 100%;
        }
        input:checked
        {
            background-color: #47ff1e;
        }
        input:hover
        {
            background-color: #f6ffc1;
        }
        input:focus
        {
            background-color: #fff373;
        }
        input[type = "text"]
        {
            width: 100%;
        }
        select {
            width: 40px;
        }
        input[type="submit"] {
            display: block;
            margin-left: auto;
            margin-right: auto
        }
    </style>
</head>
<body>
    <div>
        <span>Лескова Александра, группа P3213, вариант 213999</span>
        <form method="post" name="form" id="form">
            <table class = "form">
                <tr><td></td><td></td><td rowspan="5"><canvas width="300" height="300" id="canvas">Здесь могла быть ваша реклама</canvas></td></tr>
                <tr><td>X:</td><td><input type="text" name="x" placeholder="(-5 .. 3)"></td></tr>
                <tr><td>Y:</td><td>
                    <table>
                        <input type="hidden" name="Y1">
                        <tr>
                            <td><label><input type="checkbox" name="Y" value="-2" title="">-2</label></td>
                            <td><label><input type="checkbox" name="Y" value="-0.5">-0.5</label></td>
                            <td><label><input type="checkbox" name="Y" value="1"> 1</label></td>
                        </tr>
                        <tr>
                            <td><label><input type="checkbox" name="Y" value="-1.5">-1.5</label></td>
                            <td><label><input type="checkbox" name="Y" value="0"> 0</label></td>
                            <td><label><input type="checkbox" name="Y" value="1.5"> 1.5</label></td>
                        </tr>
                        <tr>
                            <td><label><input type="checkbox" name="Y" value="-1">-1</label></td>
                            <td><label><input type="checkbox" name="Y" value="0.5"> 0.5</label></td>
                            <td><label><input type="checkbox" name="Y" value="2"> 2</label></td>
                        </tr>
                    </table>
                </td><td></td></tr>
                <tr><td>R:</td><td style="text-align: center">
                    <select name="r" onchange="draw_canvas()">
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                    </select></td><td></td></tr>
                <tr><td colspan="2"><input type="submit" onclick="return verify(this.form);"></td><td></td></tr>
            </table>
        </form>
        <table class="history">
            <tr><td> X: </td><td> Y: </td><td> R: </td><td> Результат: </td></tr>
            <%  if (application.getAttribute("history") != null && (application.getAttribute("history") instanceof String) ) { %>
            <%= (String)application.getAttribute("history") %>
            <% } %>
        </table>
    </div>
</body>
</html>
