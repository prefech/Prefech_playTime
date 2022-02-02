CREATE TABLE `prefech_playtime` (
  `id` int(11) NOT NULL,
  `steam_hex` varchar(255) NOT NULL,
  `playTime` int(11) NOT NULL,
  `lastJoin` int(11) NOT NULL,
  `lastLeave` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `prefech_playtime`
  ADD PRIMARY KEY (`id`);


ALTER TABLE `prefech_playtime`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
COMMIT;