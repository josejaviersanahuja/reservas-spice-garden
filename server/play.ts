import * as bcrypt from 'bcrypt';

const password = '123456';
const hash = '$2b$10$0heNSVYQMeYBzyfYSSdyE.fBY.GBhg6iQN/0apzPZEgtdMaI70O32';
bcrypt.compare(password, hash).then((result) => {
  console.log(result);
});
