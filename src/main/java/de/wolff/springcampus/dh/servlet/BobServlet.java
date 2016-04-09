package de.wolff.springcampus.dh.servlet;

public class BobServlet extends DhKeyExchangeServlet {

    @Override
    protected Role getRole() {
        return Role.BOB;
    }
}
