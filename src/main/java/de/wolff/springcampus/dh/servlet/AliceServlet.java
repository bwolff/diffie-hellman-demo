package de.wolff.springcampus.dh.servlet;

public class AliceServlet extends DhKeyExchangeServlet {

    @Override
    protected Role getRole() {
        return Role.ALICE;
    }
}
