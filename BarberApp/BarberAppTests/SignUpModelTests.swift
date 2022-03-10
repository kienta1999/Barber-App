//
//  SignUpModelTests.swift
//  BarberAppTests
//
//  Created by 최지원 on 2/28/22.
//
import XCTest
@testable import BarberApp

class SignUpModelTests: XCTestCase {
    
    var sut: User!
    let id = "J"
    let firstname = "H"
    let lastname = "K"
    let email = "c@gmail.com"
    let password = "123456"
    let role = "Barber"

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }
    
    //Test if the instance can be created
    func testUser_newInstanceCreated() {
            sut = User(id: id,
                       firstname: firstname,
                       lastname: lastname,
                       email: email,
                       password: password,
                       role: role)
            
            XCTAssertNotNil(sut)
         }
    
    func testUser_fields() {
        sut = User(id: id,
                   firstname: firstname,
                   lastname: lastname,
                   email: email,
                   password: password,
                   role: role)
        
        XCTAssertTrue(sut.validateSignupField())
    }
    
    func testUser_emptyFirstName() {
            sut = User(id: id,
                       firstname: "   ",
                       lastname: lastname,
                       email: email,
                       password: password,
                       role: role)
            
        XCTAssertFalse(sut.validateSignupField())
         }
    
    func testUser_emptyLastName() {
            sut = User(id: id,
                       firstname: firstname,
                       lastname: "   ",
                       email: email,
                       password: password,
                       role: role)
            
        XCTAssertFalse(sut.validateSignupField())
         }
    
    func testUser_emptyEmail() {
            sut = User(id: id,
                       firstname: firstname,
                       lastname: lastname,
                       email: "   ",
                       password: password,
                       role: role)
            
        XCTAssertFalse(sut.validateSignupField())
         }
    
    func testUser_emptyPassword() {
            sut = User(id: id,
                       firstname: firstname,
                       lastname: lastname,
                       email: email,
                       password: "   ",
                       role: role)
            
            XCTAssertFalse(sut.validatePassword())
         }
    
    func testUser_invalidPasswordLength() {
            sut = User(id: id,
                       firstname: firstname,
                       lastname: lastname,
                       email: email,
                       password: "14",
                       role: role)
            
            XCTAssertFalse(sut.validatePassword())
    }
    
    func testUser_invalidPasswordCharacter() {
            sut = User(id: id,
                       firstname: firstname,
                       lastname: lastname,
                       email: email,
                       password: "absdfe",
                       role: role)
            
            XCTAssertFalse(sut.validatePassword())
    }
    
    func testUser_invalidPasswordCharacterAndLength() {
            sut = User(id: id,
                       firstname: firstname,
                       lastname: lastname,
                       email: email,
                       password: "klw",
                       role: role)
            
            XCTAssertFalse(sut.validatePassword())
    }
    
    func testUser_validPassword() {
            sut = User(id: id,
                       firstname: firstname,
                       lastname: lastname,
                       email: email,
                       password: "123456",
                       role: role)
            
            XCTAssertTrue(sut.validatePassword())
    }
    
    func testUser_invalidLoginField() {
            sut = User(id: id,
                       firstname: firstname,
                       lastname: lastname,
                       email: email,
                       password: "   ",
                       role: role)
            
            XCTAssertFalse(sut.validateLoginField())
    }
    
    func testUser_validLoginField() {
            sut = User(id: id,
                       firstname: firstname,
                       lastname: lastname,
                       email: email,
                       password: "123456",
                       role: role)
            
            XCTAssertTrue(sut.validateLoginField())
    }
}
