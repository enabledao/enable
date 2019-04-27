import React from "react";
import { faSearch } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  Navbar,
  NavbarToggler,
  NavbarBrand,
  Nav,
  NavItem,
  NavLink,
  Dropdown,
  DropdownToggle,
  DropdownMenu,
  DropdownItem,
  InputGroup,
  InputGroupAddon,
  InputGroupText,
  FormInput,
  Collapse
} from "shards-react";

import { Link } from "react-router-dom";

interface MyState {
  dropdownOpen: boolean
  collapseOpen: boolean
};

export class PrimaryNav extends React.Component<{}, MyState> {
  constructor(props) {
    super(props);

    this.toggleDropdown = this.toggleDropdown.bind(this);
    this.toggleNavbar = this.toggleNavbar.bind(this);

    this.state = {
      dropdownOpen: false,
      collapseOpen: false
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
    return (
      <Navbar type="dark" theme="primary" expand="md">
        <NavbarBrand href="/">Enable</NavbarBrand>
        <NavbarToggler onClick={this.toggleNavbar} />

        <Collapse open={this.state.collapseOpen} navbar>
          <Nav navbar>
            <Dropdown
              open={this.state.dropdownOpen}
              toggle={this.toggleDropdown}
            >
              <DropdownToggle nav caret>
                Loans
              </DropdownToggle>
              <DropdownMenu>
                <DropdownItem><Link to="/loan/Education">Education</Link></DropdownItem>
                <DropdownItem><Link>Agriculture</Link></DropdownItem>
                <DropdownItem><Link>Mission-driven Orgs</Link></DropdownItem>
              </DropdownMenu>
            </Dropdown>

            <InputGroup size="sm" seamless>
              <InputGroupAddon type="prepend">
                <InputGroupText>
                  <FontAwesomeIcon icon={faSearch} />
                </InputGroupText>
              </InputGroupAddon>
              <FormInput placeholder="Search..." />
            </InputGroup>
          </Nav>

          <Nav navbar className="ml-auto">
            <NavItem>
              <NavLink href="#">
                Borrow
              </NavLink>
            </NavItem>
            <NavItem>
              <NavLink href="#">
                About
              </NavLink>
            </NavItem>
            <NavItem>
              <NavLink href="#">
                Sign In
              </NavLink>
            </NavItem>
          </Nav>
        </Collapse>
      </Navbar>
    );
  }
}