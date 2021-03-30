FROM cypress/base:14.16.0

WORKDIR /e2e

ADD package.json package-lock.json ./

RUN npm i
RUN npm i @percy/cypress@2.3.4

CMD [ "npm", "run", "test-ci", "--" ]