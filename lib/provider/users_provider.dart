import 'package:flutter/material.dart';
import 'package:music_app/models/user.dart';
import 'package:music_app/services/auth_service.dart';
import 'package:music_app/services/user_service.dart';
class UsersProvider with ChangeNotifier {
  final UsersService _service = UsersService();
  User _currentUser=User(id: 'id', firstName: 'firstName', lastName: 'lastName', email: 'email', isAdmin: false, createdAt: DateTime.now());
  List<User> _users = [];
  List<User> _followers = [];
  List<User> _following = [];

  List<User> _filtered = [];
  bool _loading = false;

  List<User> get users => _filtered;
  List<User> get followers => _followers;
  List<User> get following => _following;
  bool get loading => _loading;
  User get currentUser => _currentUser;
  Future<void> getCurrentUser() async {
    notifyListeners();
    final currentUser = await AuthenticationService().getCurrentUser();
    if (currentUser != null) {
      final fetchedUser = await UsersService().getUserById(currentUser['id']);
        _currentUser = fetchedUser!;
    
    }
    notifyListeners();
  }
  Future<void> fetchUsers() async {
    _loading = true;
    notifyListeners();

    _users = await _service.getUsers();
    _filtered = _users;

    _loading = false;
    notifyListeners();
  }
   Future<void> fetchUsersFollowing() async {
    _loading = true;
    notifyListeners();

    _following = await _service.getUsersFollowings();

    _loading = false;
    notifyListeners();
  }
   Future<void> fetchUsersFollowers() async {
    _loading = true;
    notifyListeners();

    _followers = await _service.getUsersFollowers();
    _loading = false;
    notifyListeners();
  }
  void search(String query) {
    if (query.isEmpty) {
      _filtered = _users;
    } else {
      final q = query.toLowerCase();
      _filtered = _users.where((u) {
        return u.firstName.toLowerCase().contains(q) ||
            u.lastName.toLowerCase().contains(q) ||
            u.email.toLowerCase().contains(q);
      }).toList();
    }
    notifyListeners();
  }
}
