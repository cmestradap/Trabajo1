-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 17-02-2020 a las 02:48:47
-- Versión del servidor: 10.4.11-MariaDB
-- Versión de PHP: 7.4.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `futbol`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `entrenador`
--

CREATE TABLE `entrenador` (
  `Id_Entrenador` int(5) NOT NULL,
  `FK_Id_Persona` int(5) NOT NULL,
  `FK_Id_equipo` int(5) NOT NULL,
  `anio_debut` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `entrenador`
--

INSERT INTO `entrenador` (`Id_Entrenador`, `FK_Id_Persona`, `FK_Id_equipo`, `anio_debut`) VALUES
(1, 3, 1, 2001),
(2, 4, 4, 1990),
(3, 10, 3, 2014),
(4, 8, 6, 2001),
(5, 9, 5, 2000);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `equipo`
--

CREATE TABLE `equipo` (
  `Id_equipo` int(5) NOT NULL,
  `Nombre` varchar(100) NOT NULL,
  `Liga` varchar(100) NOT NULL,
  `Division` varchar(30) NOT NULL,
  `Anio_inauguracion` int(5) NOT NULL,
  `FK_Id_Estadio` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `equipo`
--

INSERT INTO `equipo` (`Id_equipo`, `Nombre`, `Liga`, `Division`, `Anio_inauguracion`, `FK_Id_Estadio`) VALUES
(1, 'Fútbol Club Barcelona', 'LaLiga, Liga de Campeones de la UEFA, Copa del Rey', 'Primera División', 1899, 1),
(3, 'Real Madrid Club de Fútbol', 'LaLiga, Liga de Campeones de la UEFA, Copa del Rey, Copa Mundial de Clubes de la FIFA', 'Primera División', 1902, 2),
(4, 'La Juventus de Turín​', 'Serie A, Liga de Campeones de la UEFA, Copa Italia, Serie B, Supercopa de Italia', 'Primera División', 1897, 5),
(5, 'Fußball-Club Bayern München e.V', 'Bundesliga, Liga de Campeones de la UEFA, MÁS', 'Primera División', 1900, 7),
(6, 'Liverpool Football Club', 'Premier League, Liga de Campeones de la UEFA, FA Cup, Copa de la Liga de Inglaterra, UEFA Europa Lea', 'Primera División', 1892, 6);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estadio`
--

CREATE TABLE `estadio` (
  `Id_estadio` int(5) NOT NULL,
  `Nombre` varchar(50) NOT NULL,
  `Ubicacion` varchar(50) NOT NULL,
  `Capacidad` int(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `estadio`
--

INSERT INTO `estadio` (`Id_estadio`, `Nombre`, `Ubicacion`, `Capacidad`) VALUES
(1, 'Camp Nou', 'C. d\'Arístides Maillol, 12, 08028 Barcelona, Españ', 99354),
(2, 'Santiago Bernabeu', 'Av. de Concha Espina, 1, 28036 Madrid, España', 81044),
(5, 'Juventus Stadium', 'Corso Gaetano Scirea, 50, 10151 Torino TO, Italia', 41000),
(6, 'Anfield', 'Anfield Rd, Anfield, Liverpool L4 0TH, Reino Unido', 54074),
(7, 'Allianz Arena', 'Werner-Heisenberg-Allee 25, 80939 München, Alemani', 75024);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `futbolista`
--

CREATE TABLE `futbolista` (
  `Id_Futbolista` int(5) NOT NULL,
  `Nro_Goles` int(5) NOT NULL,
  `Altura` float NOT NULL,
  `Peso` int(11) NOT NULL,
  `Dorsal` int(11) NOT NULL,
  `Posicion` varchar(20) NOT NULL,
  `FK_Id_persona` int(5) NOT NULL,
  `FK_Id_Entrenador` int(5) NOT NULL,
  `FK_Id_Equipo` int(5) NOT NULL,
  `FK_Id_Estadio` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `futbolista`
--

INSERT INTO `futbolista` (`Id_Futbolista`, `Nro_Goles`, `Altura`, `Peso`, `Dorsal`, `Posicion`, `FK_Id_persona`, `FK_Id_Entrenador`, `FK_Id_Equipo`, `FK_Id_Estadio`) VALUES
(2, 622, 1.7, 72, 10, 'Delantero', 1, 1, 1, 1),
(3, 624, 1.87, 83, 7, 'Delantero', 2, 2, 4, 5),
(5, 69, 1.74, 69, 10, 'Extremo', 5, 4, 6, 6),
(6, 171, 1.75, 70, 11, 'Delantero', 6, 4, 6, 6),
(7, 0, 1.73, 73, 10, 'Delantero', 7, 2, 4, 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `persona`
--

CREATE TABLE `persona` (
  `id_persona` int(5) NOT NULL,
  `Nombre` varchar(50) NOT NULL,
  `Apellidos` varchar(50) NOT NULL,
  `Apodo` varchar(30) DEFAULT NULL,
  `Edad` int(3) NOT NULL,
  `Nacionalidad` varchar(30) NOT NULL,
  `Fecha_Nacimiento` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `persona`
--

INSERT INTO `persona` (`id_persona`, `Nombre`, `Apellidos`, `Apodo`, `Edad`, `Nacionalidad`, `Fecha_Nacimiento`) VALUES
(1, 'Lionel Andrés', ' Messi Cuccittini', 'La pulga', 32, 'Argentina', '1987-06-24'),
(2, 'Cristiano Ronaldo', 'dos Santos Aveiro', 'El bicho', 35, 'Portuguesa', '1985-02-05'),
(3, 'Enrique', 'Setién Solar', 'Quique Setién', 61, 'Española', '1958-09-27'),
(4, 'Maurizio', 'Sarri', 'Míster 33', 61, 'Italiana', '1959-01-10'),
(5, 'Sadio ', 'Mané', 'Sad10', 27, 'Senegalesa', '1992-04-10'),
(6, 'Mohamed ', 'Salah Hamed', 'Faraón', 27, 'Egipcia', '1992-06-15'),
(7, 'Paulo Exequiel', 'Dybala Suárez', 'La joya', 26, 'Argentina', '1993-11-15'),
(8, 'Jürgen', ' Norbert  Klopp', 'Kloppo', 52, 'Alemana', '1967-06-16'),
(9, 'Hans', 'Dieter', 'Hansi', 54, 'Alemana', '1965-02-24'),
(10, 'Zinédine Yazid', 'Zidane', 'Zizou', 47, 'Francesa', '1972-06-23');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `entrenador`
--
ALTER TABLE `entrenador`
  ADD PRIMARY KEY (`Id_Entrenador`),
  ADD KEY `FK_Id_Persona` (`FK_Id_Persona`),
  ADD KEY `FK_Id_equipo` (`FK_Id_equipo`);

--
-- Indices de la tabla `equipo`
--
ALTER TABLE `equipo`
  ADD PRIMARY KEY (`Id_equipo`),
  ADD KEY `FK_Id_Estadio` (`FK_Id_Estadio`);

--
-- Indices de la tabla `estadio`
--
ALTER TABLE `estadio`
  ADD PRIMARY KEY (`Id_estadio`);

--
-- Indices de la tabla `futbolista`
--
ALTER TABLE `futbolista`
  ADD PRIMARY KEY (`Id_Futbolista`),
  ADD KEY `FK_Id_persona` (`FK_Id_persona`),
  ADD KEY `FK_Id_Entrenador` (`FK_Id_Entrenador`),
  ADD KEY `FK_Id_Equipo` (`FK_Id_Equipo`),
  ADD KEY `FK_Id_Estadio` (`FK_Id_Estadio`);

--
-- Indices de la tabla `persona`
--
ALTER TABLE `persona`
  ADD PRIMARY KEY (`id_persona`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `entrenador`
--
ALTER TABLE `entrenador`
  MODIFY `Id_Entrenador` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `equipo`
--
ALTER TABLE `equipo`
  MODIFY `Id_equipo` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `estadio`
--
ALTER TABLE `estadio`
  MODIFY `Id_estadio` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `futbolista`
--
ALTER TABLE `futbolista`
  MODIFY `Id_Futbolista` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `persona`
--
ALTER TABLE `persona`
  MODIFY `id_persona` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `entrenador`
--
ALTER TABLE `entrenador`
  ADD CONSTRAINT `entrenador_ibfk_1` FOREIGN KEY (`FK_Id_Persona`) REFERENCES `persona` (`id_persona`) ON UPDATE CASCADE,
  ADD CONSTRAINT `entrenador_ibfk_2` FOREIGN KEY (`FK_Id_equipo`) REFERENCES `equipo` (`Id_equipo`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `equipo`
--
ALTER TABLE `equipo`
  ADD CONSTRAINT `equipo_ibfk_1` FOREIGN KEY (`FK_Id_Estadio`) REFERENCES `estadio` (`Id_estadio`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `futbolista`
--
ALTER TABLE `futbolista`
  ADD CONSTRAINT `futbolista_ibfk_1` FOREIGN KEY (`FK_Id_persona`) REFERENCES `persona` (`id_persona`) ON UPDATE CASCADE,
  ADD CONSTRAINT `futbolista_ibfk_2` FOREIGN KEY (`FK_Id_Entrenador`) REFERENCES `entrenador` (`Id_Entrenador`) ON UPDATE CASCADE,
  ADD CONSTRAINT `futbolista_ibfk_3` FOREIGN KEY (`FK_Id_Equipo`) REFERENCES `equipo` (`Id_equipo`) ON UPDATE CASCADE,
  ADD CONSTRAINT `futbolista_ibfk_4` FOREIGN KEY (`FK_Id_Estadio`) REFERENCES `estadio` (`Id_estadio`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
