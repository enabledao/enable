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
              className="w-100 mr-0"
              href="#"
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
            <Nav navbar className="ml-auto app__navbar-button">
              <NavItem>
                <Link to="/dashboard">
                  <Button theme="primary">Dashboard</Button>
                </Link>
              </NavItem>
            </Nav>
            {/* <NavbarToggler onClick={this.toggleNavbar} /> */}

            {/* <Collapse open={this.state.collapseOpen} navbar>
              <Nav navbar>
                <Dropdown
                  open={this.state.dropdownOpen}
                  toggle={this.toggleDropdown}
                >
                  <DropdownToggle nav caret>
                    Loans
                  </DropdownToggle>
                  <DropdownMenu>
                    <DropdownItem>
                      <Link to="/loan/Education">Education</Link>
                    </DropdownItem>
                    <DropdownItem>
                      <Link>Agriculture</Link>
                    </DropdownItem>
                    <DropdownItem>
                      <Link>Mission-driven Orgs</Link>
                    </DropdownItem>
                  </DropdownMenu>
                </Dropdown>
              </Nav>

              <Nav navbar className="ml-auto">
                <NavItem>
                  <Link to="/dashboard">
                    <Button theme="primary">Dashboard</Button>
                  </Link>
                </NavItem>
              </Nav>
            </Collapse> */}
          </Navbar>
        </Container>
      </div>
    );
  }
}
