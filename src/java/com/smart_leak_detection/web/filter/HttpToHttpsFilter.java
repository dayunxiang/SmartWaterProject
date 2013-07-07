package com.smart_leak_detection.web.filter;
 
import java.io.IOException;
 
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
 
//instead of defining the filter in our web.xml we will use an annotation
@WebFilter("/welcome.jsp")
public class HttpToHttpsFilter implements Filter {
 
    @Override
    public void init(FilterConfig config) throws ServletException {
        // if you have any init-params in web.xml then you could retrieve them
        // here by calling config.getInitParameter("my-init-param-name").
        // example: you could define a comma separated list of paths that should be
        // checked for http to https redirection
    }
 
    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
 
        System.out.println("HttpToHttpsFilter: URL requested = "+request.getRequestURL().toString());
         
        if ( !request.isSecure() ) {
            String url = request.getRequestURL().toString().replaceFirst("http", "https");
            url = url.replaceFirst(":8080/", ":8181/");  //quick and dirty!!!
             
            //don't forget to add the parameters
            if (request.getQueryString() != null) 
                url += "?" + request.getQueryString();
            System.out.println("HttpToHttpsFilter redirect to: "+url);
            response.sendRedirect(url);
        } else {
            chain.doFilter(req, res); // we already have a https connection ==> so just continue request
        }
    }
 
    @Override
    public void destroy() {
        // release resources if you have any
    }
 
}