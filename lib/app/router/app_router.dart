import 'package:flutter/material.dart';
import 'package:flutter_supabase_auth/app/widgets/navbar/scaffold_with_nav_bar.dart';
import 'package:flutter_supabase_auth/core/enums/auth_status.dart';
import 'package:flutter_supabase_auth/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_supabase_auth/features/auth/presentation/views/auth_view.dart';
import 'package:flutter_supabase_auth/features/home/presentation/views/home_view.dart';
import 'package:flutter_supabase_auth/features/profile/presentation/views/profile_view.dart';
import 'package:flutter_supabase_auth/features/profile/presentation/views/user_profile_view.dart';
import 'package:flutter_supabase_auth/locator.dart';
import 'package:go_router/go_router.dart';

/// The [AppRouter] class is responsible for configuring the GoRouter
final class AppRouter {
  /// The [GlobalKey] for the home navigator
  static final _shellNavigatorHome = GlobalKey<NavigatorState>(
    debugLabel: 'shellHome',
  );

  /// The [GlobalKey] for the profile navigator
  static final _shellNavigatorProfile = GlobalKey<NavigatorState>(
    debugLabel: 'shellProfile',
  );

  /// Route Names
  static const String userProfile = 'UserProfile';

  /// The [AuthRefreshNotifier] instance
  static final AuthRefreshNotifier _authRefreshNotifier = AuthRefreshNotifier(
    Locator.authBloc.stream,
  );

  /// The [GoRouter] instance
  static final router = GoRouter(
    initialLocation: '/auth',
    redirect: _guard,
    refreshListenable: _authRefreshNotifier,
    routes: [
      /// Auth View
      GoRoute(
        path: '/auth',
        name: 'Auth',
        builder: (BuildContext context, GoRouterState state) =>
            const AuthView(),
      ),

      /// User Profile View
      GoRoute(
        path: '/user-profile/:id',
        name: userProfile,
        builder: (BuildContext context, GoRouterState state) {
          final userId = state.pathParameters['id'] ?? '';
          return UserProfileView(userId: userId);
        },
      ),

      /// Dashboard View
      StatefulShellRoute.indexedStack(
        builder:
            (
              BuildContext context,
              GoRouterState state,
              StatefulNavigationShell navigationShell,
            ) {
              // Return the widget that implements the custom shell (in this case
              // using a BottomNavigationBar). The StatefulNavigationShell is passed
              // to be able access the state of the shell and to navigate to other
              // branches in a stateful way.
              return ScaffoldWithNavBar(navigationShell: navigationShell);
            },
        branches: [
          /// Home View
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHome,
            routes: [
              GoRoute(
                path: '/home',
                name: 'Home',
                builder: (BuildContext context, GoRouterState state) =>
                    const HomeView(),
              ),
            ],
          ),

          /// Profile View
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfile,
            routes: [
              GoRoute(
                path: '/profile',
                name: 'Profile',
                builder: (BuildContext context, GoRouterState state) =>
                    const ProfileView(),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  /// Handles authentication-based redirection in the GoRouter configuration.
  static String? _guard(BuildContext context, GoRouterState state) {
    final authState = Locator.authBloc.state;
    final status = authState.status;

    /// Determines if the user is authenticated.
    final isAuthenticated = status == AuthStatus.authenticated;

    /// Checks whether the current route is the authentication page.
    final isOnAuthRoute = state.matchedLocation == '/auth';

    /// If the status is loading, no redirection is required.
    if (status == AuthStatus.loading || status == AuthStatus.error) {
      return null;
    }

    /// Redirects unauthenticated users to the authentication page,
    /// unless they are already on the authentication page.
    if (!isAuthenticated && !isOnAuthRoute) {
      return '/auth';
    }

    /// Redirects authenticated users away from the authentication page
    /// to the home page if they are still on the authentication screen.
    if (isAuthenticated && isOnAuthRoute) {
      return '/home';
    }

    /// No redirection is required.
    return null;
  }
}

/// A ChangeNotifier that listens to authentication state changes
/// and triggers a refresh in GoRouter when the state updates.
class AuthRefreshNotifier extends ChangeNotifier {
  /// Subscribes to authentication state changes and notifies listeners
  /// whenever the state updates.
  AuthRefreshNotifier(this.stream) {
    stream.listen((state) {
      notifyListeners();
    });
  }
  final Stream<AuthState> stream;
}
