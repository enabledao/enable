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

interface MyState {
  dropdownOpen: boolean
  collapseOpen: boolean
};

export default class PrimaryNav extends React.Component<{}, MyState> {
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
                <DropdownItem>Education</DropdownItem>
                <DropdownItem>Agriculture</DropdownItem>
                <DropdownItem>Mission-driven Orgs</DropdownItem>
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
            <NavLink href="#">
              Borrow
              </NavLink>

            <NavLink href="#">
              About
              </NavLink>

            <NavLink href="#">
              Sign In
              </NavLink>
          </Nav>
        </Collapse>
      </Navbar>
    );
  }
}