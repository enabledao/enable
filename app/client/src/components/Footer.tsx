import React from "react";
import {
  Navbar,
  Nav,
  NavItem,
  NavLink,
} from "shards-react";
import { Link } from "react-router-dom";

export class Footer extends React.Component {

  render() {
    return (
      <Navbar type="dark" className="footer" expand="md" style={{ background: "transparent", borderTop: "solid 2px rgba(0,0,0,0.1)" }}>
        <Nav navbar>
            <NavItem>
                <NavLink href="/" >Home</NavLink>
            </NavItem>
        </Nav>

        <Nav navbar className="ml-auto">
            <NavItem >
                Copyright © 2018 DesignRevision
            </NavItem>
        </Nav>
      </Navbar>
    );
  }
}