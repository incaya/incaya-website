---
title: Une micro-caméra pour photographier la faune - le détecteur de mouvement
slug: micro-camera-faune-pir
description: "Poussés par notre double passion pour la faune et pour l'électronique modeste, nous vous partageons un projet de construction de micro-caméra sobre et bon marché pour découvrir le petit monde sauvage de votre jardin."
date: 2022-06-07
draft: true
in_search_index: true
tags:
- faune
- caméra
projects:
- microcam
---

Poussés par notre double passion pour la faune et pour l'électronique modeste, nous vous partageons un projet de construction de micro-caméra sobre et bon marché pour découvrir le petit monde sauvage de votre jardin.<!--more-->

### Le principe

Nous cherchons à disposer d'une caméra autonome dont les caractéristiques seraient les suivantes :

- au moins 24h d'autonomie
- stockage autonome des photos
- déclenchement par détecteur de mouvement

Il nous faudra donc assembler et programmer ensemble :

- un microcontrôleur

### Le microcontrôleur

Dans le projet MyNatureWatch que nous avons largement exploré, le Raspberry Pi zero a de nombreux avantages. Son Wifi intégré et sa caméra "prête à brancher" permettent d'envisager sa construction par un public non technicien. A contrario, cette solution est gourmande en énergie : il est difficile de dépasser 12h d'autnomie, même avec une batterie externe de grande capacité. Cette dernière ne permet pas de réaliser un dispositif très compact, de plus.

Dans ce nouveau projet, nous devons nous appuyer sur un microcontrôleur, moins souple d'un point de vue "logiciel", mais plus robuste et plus sobre en énergie.

Voilà justement un moment que le **Raspberry Pico** traîne sur notre paillasse, il est temps d'en faire quelque chose !

Sur le papier, il a [de nombreux avantages](https://www.minimachines.net/actu/raspberry-pi-pico-96697), surtout quand le dispositif n'a pas besoin d'être connecté. Il peut facilement s'intégrer dans un montage final, bien que des versions compactes soient également [disponibles](https://www.solder.party/docs/rp2040-stamp/).

### Le détecteur de mouvement

Nous avons besoin détecter les animaux pour ne déclencher que lorsque c'est pertinent. Pour celà, nous utiliserons un détecteur de mouvement à infrarouge passif (PIR).

Pour pouvoir utiliser ce capteur avec une batterie LiPo, on choisit un modèle qui s'alimente en 3V3.

Le branchement 