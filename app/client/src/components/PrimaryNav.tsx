import React from "react";
import { Link } from "react-router-dom";
import { faSearch } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  Button,
  Navbar,
  NavbarToggler,
  NavbarBrand,
  Nav,
  NavItem,
  NavLink,
  Collapse
} from "shards-react";
import { Heading } from 'rimble-ui'

interface MyState  {
    collapseOpen: boolean
  };

export default class PrimaryNav extends React.Component<{}, MyState> {
  state: MyState

  constructor(props) {
    super(props);

    this.toggleNavbar = this.toggleNavbar.bind(this);

    this.state = {
      collapseOpen: false
    };
  }

  toggleNavbar() {
    this.setState({
      ...this.state,
      ...{
        collapseOpen: !this.state.collapseOpen
      }
    });
  }

  render() {
    return (
      <Navbar type="dark" expand="md" style={{ background: "transparent", borderBottom: "solid 5px rgba(0,0,0,0.1)", padding: 0 }}>
        <NavbarBrand href="/">
          <Heading.h5>
            Enable
          </Heading.h5>
        </NavbarBrand>
        <NavbarToggler onClick={this.toggleNavbar} />

        <Collapse open={this.state.collapseOpen} navbar>
          <Nav navbar>
          </Nav>

          <Nav navbar className="ml-auto">
            <NavItem>
              <Link to="/dashboard">
                <Button theme="primary">
                  Dashboard
                </Button>
              </Link>
            </NavItem>          
          </Nav>
        </Collapse>
      </Navbar>
    );
  }
}