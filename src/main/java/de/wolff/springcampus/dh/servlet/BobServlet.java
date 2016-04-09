package de.wolff.springcampus.dh.servlet;

public class BobServlet extends DhKeyExchangeServlet {

    @Override
    protected DhRole getRole() {
        return DhRole.bob;
    }
}
