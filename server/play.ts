import * as bcrypt from 'bcrypt';

const saltOrRounds = 10;
const password = '123456';
bcrypt
  .hash(password, saltOrRounds)
  .then((hash) => {
    console.log(hash);
    return bcrypt.compare(password, hash);
  })
  .then((result) => {
    console.log(result);
  });
