/// <reference types="cypress" />

context('SPA routing - should contain current page address', () => {
  it('page-a', () => {
    cy.visit('/page-a')
    cy.get('html').should('contain', 'The current path is: /page-a')
    cy.get('html').should('not.contain', 'The current path is: /page-b')
  })

  it('page-b', () => {
    cy.visit('/page-b')
    cy.get('html').should('contain', 'The current path is: /page-b')
    cy.get('html').should('not.contain', 'The current path is: /page-a')
  })
})
