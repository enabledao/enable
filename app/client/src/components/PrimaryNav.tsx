import React from "react";
import { Link } from "react-router-dom";
import classNames from "classnames";
import {
  Container,
  Button,
  Dropdown,
  DropdownToggle,
  DropdownMenu,
  DropdownItem,
  Navbar,
  NavbarToggler,
  NavbarBrand,
  Nav,
  NavItem,
  NavLink,
  Collapse
} from "shards-react";
import { Heading } from "rimble-ui";
import logo from "../assets/logo.png";

interface MyState {
  collapseOpen: boolean;
  dropdownOpen: boolean;
}

export class PrimaryNav extends React.Component<{}, MyState> {
  state: MyState;

  constructor(props) {
    super(props);

    this.toggleDropdown = this.toggleDropdown.bind(this);
    this.toggleNavbar = this.toggleNavbar.bind(this);

    this.state = {
      collapseOpen: false,
      dropdownOpen: false
    };
  }

  toggleDropdown() {
    this.setState({
      ...this.state,
      ...{
        dropdownOpen: !this.state.dropdownOpen
      }
    });
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
    const classes = classNames("main-navbar", "bg-white", "sticky-top");

    return (
      <div className={classes}>
        <Container className="p-0">
          <Navbar
            type="light"
            className="align-items-stretch ml-2 flex-md-nowrap p-0"
          >
            <NavbarBrand
              className="mr-0"
              href="/"
              style={{ lineHeight: "25px" }}
            >
              <img
                id="main-logo"
                className="d-inline-block align-top mr-2"
                src={logo}
                alt=""
                height="32"
              />
              <span className="md-inline ml-1">
                <h5
                  className="app__brand-name"
                  // style={{
                  //   lineHeight: "34px"
                  // }}
                >
                  Enable
                </h5>
              </span>
            </NavbarBrand>
            <Nav navbar className="ml-auto app__navbar-button mr-2">
              <NavItem>
                <Link to="/loan/1">
                  <Button theme="primary">Loan</Button>
                </Link>
              </NavItem>
            </Nav>
          </Navbar>
        </Container>
      </div>
    );
  }
}
