FROM cypress/included:6.8.0

WORKDIR /e2e

ADD . .

RUN npm i
RUN npm i @percy/cypress@2.3.4

CMD [ "npm", "run", "test-ci" ]