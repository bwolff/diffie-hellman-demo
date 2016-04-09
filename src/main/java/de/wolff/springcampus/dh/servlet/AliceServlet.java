package de.wolff.springcampus.dh.servlet;

public class AliceServlet extends DhKeyExchangeServlet {

    @Override
    protected DhRole getRole() {
        return DhRole.alice;
    }
}
