-- CreateTable
CREATE TABLE "Prioridade" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "descPrioridade" TEXT NOT NULL
);

-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Chamado" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "nomeChamado" TEXT NOT NULL,
    "descChamado" TEXT NOT NULL,
    "dataAberturaChamado" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "idUsuario" INTEGER NOT NULL,
    "idSuporte" INTEGER,
    "idLab" INTEGER NOT NULL,
    "idComputador" INTEGER NOT NULL,
    "idCategoria" INTEGER NOT NULL,
    "idAndamento" INTEGER NOT NULL DEFAULT 1,
    "tratInicio" DATETIME,
    "tratFim" DATETIME,
    "idPrioridade" INTEGER NOT NULL DEFAULT 1,
    CONSTRAINT "Chamado_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES "Usuario" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Chamado_idSuporte_fkey" FOREIGN KEY ("idSuporte") REFERENCES "Usuario" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "Chamado_idLab_fkey" FOREIGN KEY ("idLab") REFERENCES "Lab" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Chamado_idComputador_fkey" FOREIGN KEY ("idComputador") REFERENCES "Computador" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Chamado_idCategoria_fkey" FOREIGN KEY ("idCategoria") REFERENCES "Categoria" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Chamado_idAndamento_fkey" FOREIGN KEY ("idAndamento") REFERENCES "Andamento" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Chamado_idPrioridade_fkey" FOREIGN KEY ("idPrioridade") REFERENCES "Prioridade" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_Chamado" ("dataAberturaChamado", "descChamado", "id", "idAndamento", "idCategoria", "idComputador", "idLab", "idSuporte", "idUsuario", "nomeChamado", "tratFim", "tratInicio") SELECT "dataAberturaChamado", "descChamado", "id", "idAndamento", "idCategoria", "idComputador", "idLab", "idSuporte", "idUsuario", "nomeChamado", "tratFim", "tratInicio" FROM "Chamado";
DROP TABLE "Chamado";
ALTER TABLE "new_Chamado" RENAME TO "Chamado";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
