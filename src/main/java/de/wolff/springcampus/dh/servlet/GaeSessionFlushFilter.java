package de.wolff.springcampus.dh.servlet;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;


/**
 * This filter class is a "hack" that writes a new value to the HttpSession, which is a custom GAE
 * implementation, in order to trigger a flush of the session data to the GAE datastore and memcache
 * after every request. This is to avoid potential stale data in the HttpSession. We store the
 * DhKeyExchange instance in the session and modifications made to this instance may not be detected
 * by the automatic flush detection.
 *
 * For details see:
 *
 * https://stackoverflow.com/questions/19259457/session-lost-in-google-app-engine-using-jsf
 * http://afewguyscoding.com/2011/02/httpsession-google-app-engine/
 *
 */
public class GaeSessionFlushFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        try {
            chain.doFilter(request, response);
        } finally {
            writeNewDataToSession((HttpServletRequest) request);
        }
    }

    @Override
    public void destroy() {
    }

    private void writeNewDataToSession(HttpServletRequest request) {
        request.getSession().setAttribute("CURRENT_TIME", String.valueOf(System.nanoTime()));
    }
}
