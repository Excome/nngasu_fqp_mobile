enum Role {
  ROLE_GUEST,
  ROLE_USER,
  ROLE_TEACHER,
  ROLE_TECHNICIAN,
  ROLE_MODERATOR,
  ROLE_ADMIN
}

extension RoleExt on Role {
  int get id {
    switch (this) {
      case Role.ROLE_GUEST:
        return 0;
      case Role.ROLE_USER:
        return 1;
      case Role.ROLE_TEACHER:
        return 2;
      case Role.ROLE_TECHNICIAN:
        return 3;
      case Role.ROLE_MODERATOR:
        return 4;
      case Role.ROLE_ADMIN:
        return 5;
    }
  }

  int get priority {
    switch (this) {
      case Role.ROLE_GUEST:
        return 100;
      case Role.ROLE_USER:
        return 200;
      case Role.ROLE_TEACHER:
        return 400;
      case Role.ROLE_TECHNICIAN:
        return 500;
      case Role.ROLE_MODERATOR:
        return 700;
      case Role.ROLE_ADMIN:
        return 1000;
    }
  }

  String get translation {
    switch (this) {
      case Role.ROLE_GUEST:
        return "Гость";
      case Role.ROLE_USER:
        return "Пользователь";
      case Role.ROLE_TEACHER:
        return "Преподаватель";
      case Role.ROLE_TECHNICIAN:
        return "Техник";
      case Role.ROLE_MODERATOR:
        return "Модератор";
      case Role.ROLE_ADMIN:
        return "Администратор";
    }
  }
}