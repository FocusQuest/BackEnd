/*
  Warnings:

  - Added the required column `idComputador` to the `Chamado` table without a default value. This is not possible if the table is not empty.
  - Added the required column `idLab` to the `Chamado` table without a default value. This is not possible if the table is not empty.
  - Added the required column `nomeChamado` to the `Chamado` table without a default value. This is not possible if the table is not empty.

*/
-- CreateTable
CREATE TABLE "Lab" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "nomeLab" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "Computador" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "nomeComp" TEXT NOT NULL,
    "idLab" INTEGER NOT NULL,
    CONSTRAINT "Computador_idLab_fkey" FOREIGN KEY ("idLab") REFERENCES "Lab" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Chamado" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "nomeChamado" TEXT NOT NULL,
    "descChamado" TEXT NOT NULL,
    "dataAberturaChamado" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "idUsuario" INTEGER NOT NULL,
    "idLab" INTEGER NOT NULL,
    "idComputador" INTEGER NOT NULL,
    "idCategoria" INTEGER NOT NULL,
    "idAndamento" INTEGER NOT NULL DEFAULT 1,
    "tratInicio" DATETIME,
    "tratFim" DATETIME,
    "idSuporte" INTEGER,
    CONSTRAINT "Chamado_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES "Usuario" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Chamado_idLab_fkey" FOREIGN KEY ("idLab") REFERENCES "Lab" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Chamado_idComputador_fkey" FOREIGN KEY ("idComputador") REFERENCES "Computador" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Chamado_idCategoria_fkey" FOREIGN KEY ("idCategoria") REFERENCES "Categoria" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Chamado_idAndamento_fkey" FOREIGN KEY ("idAndamento") REFERENCES "Andamento" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Chamado_idSuporte_fkey" FOREIGN KEY ("idSuporte") REFERENCES "Suporte" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);
INSERT INTO "new_Chamado" ("dataAberturaChamado", "descChamado", "id", "idAndamento", "idCategoria", "idSuporte", "idUsuario", "tratFim", "tratInicio") SELECT "dataAberturaChamado", "descChamado", "id", "idAndamento", "idCategoria", "idSuporte", "idUsuario", "tratFim", "tratInicio" FROM "Chamado";
DROP TABLE "Chamado";
ALTER TABLE "new_Chamado" RENAME TO "Chamado";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;

-- CreateIndex
CREATE UNIQUE INDEX "Computador_nomeComp_key" ON "Computador"("nomeComp");
