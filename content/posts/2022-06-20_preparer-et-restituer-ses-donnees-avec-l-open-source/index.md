---
title: Préparer et restituer ses données avec l'open source
slug: preparer-et-restituer-ses-donnees-avec-l-open-source
description: "Alors qu'il existe pléthore de logiciels propriétaires pour transformer et restituer ses données, l'open-source est une réelle option pour les petits budgets"
date: 2022-06-20T09:51:14Z
draft: false
in_search_index: true
tags:
- open-source
- dataflow
- dataviz
---

Alors qu'il existe pléthore de logiciels propriétaires pour transformer et restituer ses données, l'open-source est une option pour les petits budgets.

## Introduction

A l'ère du trop plein de données, des big data, machine learning et consorts, on semble oublier que le plus grand nombre a des besoins plus modestes malgré parfois une hétérogénéité des données à exploiter.

Quelque soit le domaine d'exploration, les données à visualiser peuvent provenir :
- de fichiers (CSV, JSON, XML, ...)
- de bases de données alimentées par des systèmes de gestion divers
- d'[API](https://fr.wikipedia.org/wiki/Interface_de_programmation)
- etc ...

L'enjeu avant de pouvoir faire de la [data visualisation](https://fr.wikipedia.org/wiki/Visualisation_de_donn%C3%A9es) est d'assembler et consolider toutes les données à disposition, de les transformer et les nettoyer pour en faciliter l'exploitation.
On résume cela par les acronymes [ETL](https://fr.wikipedia.org/wiki/Extract-transform-load) ou [ELT](https://fr.wikipedia.org/wiki/Extract_load_transform) dans le but de construire un [entrepôt de données](https://fr.wikipedia.org/wiki/Entrep%C3%B4t_de_donn%C3%A9es).

Parfois, quand la quantité d'étapes de transformation le justifie, on peut avoir recours à un orchestrateur de données ou gestionnaire de [dataflow](https://fr.wikipedia.org/wiki/Architecture_Dataflow).

Dans le domaine, l'open source répond par une large [galaxie d'outils](https://snowplowanalytics.com/wp-content/uploads/sites/3/2021/07/v8-Architas-3.png) (non exhaustive).

## En quête de simplicité

Cette offre open-source abondante permet d'envisager des architectures des plus complexes aux plus simples pour ce qui concerne le traitement des données. 

L'enjeu de la simplicité se joue à plusieurs niveaux :
- être en mesure d'importer des données hétérogènes sans alourdir la chaîne de traitement
- donner aux développeurs la capacité à produire vite dans un environnement maîtrisé
- limiter l'effort de maintenance en utilisant des outils légers et stables

Chez Incaya, nous apprécions tout particulièrement des outils comme [Python](https://fr.wikipedia.org/wiki/Python_(langage)) et [DBT](https://www.getdbt.com/) qui répondent parfaitement à ces objectifs. Par ailleurs, nous suivons avec attention le projet [Airbyte](https://airbyte.com/) qui s'avère très efficace pour le chargement des données depuis un grand nombre de types de source.

## La visualisation de données pour toutes et tous

Habitué par le passé aux outils propriétaires forcément (quoique) bien conçus, j'étais (Thomas) souvent déçu par l'offre open-source de visualisation de données (je parle d'un temps ... bref avant 2015, en gros). Il y manquait toujours l'une ou l'autre de ces fonctionnalités souvent très attendues :
- accéder aux données à restituer sans contrainte
- fournir aux utilisatrices et utilisateurs un accès personnalisé, tou.te.s n'ayant pas les mêmes besoins, entre simplement utiliser les tableaux de bord et pouvoir en concevoir
- disposer d'un catalogue de types de visualisation suffisant pour couvrir les besoins d'analyse

Aussi, dans ce domaine, l'offre open-source n'est de loin pas composée que d'[outils libres](https://fr.wikipedia.org/wiki/Logiciel_libre), ce qui contraint parfois à souscrire à une offre payante dans le cloud (ou pas) pour disposer de l'ensemble des fonctionnalités attendues.

Pour cocher toutes les cases, et bien que ce ne soit pas la seule solution, nous avons été séduit par le projet [Superset](https://superset.apache.org/) porté par la puissante communauté [Apache](https://projects.apache.org/). Notons que les visualisations à disposition repose notamment sur le très robuste librairie [D3.js](https://d3js.org/) que l'on peut même utiliser seule pour intégrer des indicateurs dans un [site ou une application web (webapp)](https://dev.to/lawalalao/quelle-est-la-difference-entre-un-site-web-et-une-application-web-2ml1).

## Notre démarche

Nous sommes avant tout soucieux de pouvoir fournir des tableaux de bord au plus grand nombre, notamment dans des domaines d'activité où les budgets sont réduits - de la plus petite association ou collectivité à la PME oeuvrant dans l'ESS par exemple.

Par ailleurs, il n'est pas rare que nous travaillons pour des projets où la visualisation de données soit "la cerise sur le gâteau", par exemple quand il s'agit de fournir de simples indicateurs dans le cadre d'une collecte de données de sciences participatives. L'open-source répond alors parfaitement pour limiter les coûts tout en offrant la souplesse nécessaire de part la qualité des outils à disposition.

Enfin, notre expérience est autant appréciée pour notre connaissance des outils que dans notre capacité à accompagner nos clients dans l'organisation de leurs données et le choix d'indicateurs pertients. En fonction des choix technologiques décidés avec nos clients, nous pouvons par ailleurs compter sur un grand nombre d'experts dans la communauté des sociétés coopératives du numérique.
