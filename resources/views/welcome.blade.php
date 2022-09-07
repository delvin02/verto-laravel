@extends('layouts.layout')
@section('content')

        <div id="app">
            <search-bar></search-bar>
            <Display :likedImg="likedImg"/>
        </div>
@endsection
