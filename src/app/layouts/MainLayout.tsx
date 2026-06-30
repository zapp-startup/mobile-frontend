import React from 'react';
import { Outlet } from 'react-router';
import { MainTabNavigator } from '../../navigation/MainTabNavigator';

export const MainLayout: React.FC = () => {
  return (
    <>
      <Outlet />
      <MainTabNavigator />
    </>
  );
};
